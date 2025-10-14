/* docs/assets/js/wx-hero.js */
(function () {
  'use strict';

  const clamp = (n, min, max) => Math.min(max, Math.max(min, n));

  function toRGB(colorString, fallback = { r: 26, g: 115, b: 232 }) {
    if (!colorString) return fallback;
    const el = document.createElement('span');
    el.style.color = colorString.trim();
    document.body.appendChild(el);
    const rgb = getComputedStyle(el).color;
    document.body.removeChild(el);
    const m = rgb.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/i);
    return m ? { r: +m[1], g: +m[2], b: +m[3] } : fallback;
  }

  function readColorVar(name, fallback) {
    const raw = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
    return toRGB(raw || '', fallback);
  }

  function rafThrottle(fn) {
    let queued = false;
    return function (...args) {
      if (queued) return;
      queued = true;
      requestAnimationFrame(() => { queued = false; fn.apply(this, args); });
    };
  }

  function mount() {
    const canvas = document.getElementById('wx-bubbles');
    const bg = document.querySelector('.wx-hero__bg');
    if (!canvas || canvas.__wxMounted) return;
    canvas.__wxMounted = true;

    const ctx = canvas.getContext('2d', { alpha: true });
    if (!ctx) return;

    const prefersReduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
    const BASE = readColorVar('--wx-blue', { r: 11, g: 98, b: 163 });
    const DPR = clamp(window.devicePixelRatio || 1, 1, 2);

    let W = 0, H = 0, particles = [], rafId = null, running = false;

    // Tuned for visibility
    const AREA_DIVISOR = 7000; // Lower value = more particles per area
    const COUNT_MIN = 120, COUNT_MAX = 250; // Increased particle count
    const LINK_DIST = 180; // Increased connection distance for more lines
    const MAX_NEIGHBORS = 3;
    const SPEED = 0.35;

    function makeParticle() {
      const size = Math.random() * 2.5 + 1.0; // Increased particle size
      return {
        x: Math.random() * W,
        y: Math.random() * H,
        r: size,
        a: Math.random() * 0.45 + 0.25,
        vx: (Math.random() - 0.5) * 0.35,
        vy: (Math.random() - 0.5) * 0.35,
        tw: Math.random() * Math.PI * 2
      };
    }

    function sizeNow() {
      const host = canvas.parentElement || document.body;
      const rect = host.getBoundingClientRect();
      W = Math.max(1, Math.floor(rect.width));
      H = Math.max(1, Math.floor(rect.height));

      canvas.width = Math.floor(W * DPR);
      canvas.height = Math.floor(H * DPR);
      canvas.style.width = W + 'px';
      canvas.style.height = H + 'px';
      ctx.setTransform(DPR, 0, 0, DPR, 0, 0);

      const target = clamp(Math.floor((W * H) / AREA_DIVISOR), COUNT_MIN, COUNT_MAX);
      if (particles.length !== target) {
        particles = Array.from({ length: target }, makeParticle);
      }
    }

    function draw(t) {
      if (!running) return;
      ctx.clearRect(0, 0, W, H);

      const linkDistSq = LINK_DIST * LINK_DIST;
      const fillBase = `rgba(${BASE.r},${BASE.g},${BASE.b},`;
      const strokeBase = `rgba(${BASE.r},${BASE.g},${BASE.b},`;

      // dots
      for (let i = 0; i < particles.length; i++) {
        const p = particles[i];
        p.x += p.vx; p.y += p.vy;
        if (p.x < -10) p.x = W + 10;
        if (p.x > W + 10) p.x = -10;
        if (p.y < -10) p.y = H + 10;
        if (p.y > H + 10) p.y = -10;

        const twinkle = 0.45 + Math.sin(p.tw + t * 0.0012) * 0.25;
        const alpha = Math.min(Math.max(p.a * twinkle, 0.1), 0.75);

        const g = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.r * 6);
        g.addColorStop(0, fillBase + alpha + ')');
        g.addColorStop(1, fillBase + '0)');
        ctx.fillStyle = g;
        ctx.beginPath(); ctx.arc(p.x, p.y, p.r * 2.4, 0, Math.PI * 2); ctx.fill();
      }

      // lines
      ctx.lineWidth = clamp(1 * (1 / DPR), 0.5, 1);
      for (let i = 0; i < particles.length; i++) {
        let neighbors = 0;
        const a = particles[i];
        for (let j = i + 1; j < particles.length; j++) {
          const b = particles[j];
          const dx = a.x - b.x, dy = a.y - b.y;
          const d2 = dx * dx + dy * dy;
          if (d2 <= linkDistSq) {
            const alpha = Math.min(Math.max(1 - d2 / linkDistSq, 0), 1) * 0.5;
            ctx.strokeStyle = strokeBase + alpha + ')';
            ctx.beginPath(); ctx.moveTo(a.x, a.y); ctx.lineTo(b.x, b.y); ctx.stroke();
            if (++neighbors >= MAX_NEIGHBORS) break;
          }
        }
      }

      rafId = requestAnimationFrame(draw);
    }

    const onScroll = rafThrottle(function () {
      if (!bg) return;
      const y = window.scrollY || 0;
      bg.style.transform = 'translateY(' + y * SPEED + 'px)';
    });

    function start() {
      if (running) return;
      running = true;
      sizeNow();
      if (prefersReduced) {
        draw(performance.now()); // static frame
      } else {
        rafId = requestAnimationFrame(draw);
        window.addEventListener('scroll', onScroll, { passive: true });
      }
    }

    function stop() {
      running = false;
      if (rafId) cancelAnimationFrame(rafId);
      rafId = null;
      window.removeEventListener('scroll', onScroll);
    }

    // Resize observe + final “after CSS loaded” sizing
    let ro = null;
    if ('ResizeObserver' in window) {
      ro = new ResizeObserver(sizeNow);
      ro.observe(canvas.parentElement || canvas);
    }
    window.addEventListener('load', sizeNow, { once: true });

    // tab visibility
    const vis = () => { if (document.visibilityState === 'hidden') stop(); else start(); };
    document.addEventListener('visibilitychange', vis, { passive: true });

    start();

    // teardown for SPA route changes
    canvas.__wxTeardown = function () {
      try { ro && ro.disconnect && ro.disconnect(); } catch (e) {}
      document.removeEventListener('visibilitychange', vis);
      stop();
      ctx.clearRect(0, 0, W, H);
      canvas.__wxMounted = false;
      canvas.__wxTeardown = null;
      if (bg) bg.style.transform = '';
    };
  }

  // SPA integration
  if (window.document$ && window.document$.subscribe) {
    window.document$.subscribe(function () {
      const old = document.getElementById('wx-bubbles');
      if (old && old.__wxTeardown) old.__wxTeardown();
      mount();
    });
  } else {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', mount, { once: true });
    } else {
      mount();
    }
  }
})();