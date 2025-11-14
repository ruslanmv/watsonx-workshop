"""
MkDocs hook to remove Reveal.js speaker notes from markdown
This prevents ::: notes ... ::: blocks from appearing in the documentation
"""

import re
import logging

log = logging.getLogger('mkdocs.hooks.remove_speaker_notes')

def on_page_markdown(markdown, page, config, files):
    """
    Remove Reveal.js speaker notes before MkDocs processes the markdown

    This hook removes ::: notes ... ::: blocks that are meant only for
    Reveal.js presentations and should not appear in the documentation.
    """

    # Pattern to match ::: notes ... ::: blocks (including nested content)
    # This handles both simple and complex cases
    pattern = r'^:::\s*notes\s*\n(.*?)^:::\s*$'

    # Remove all speaker notes blocks
    cleaned_markdown = re.sub(
        pattern,
        '',
        markdown,
        flags=re.MULTILINE | re.DOTALL
    )

    # Also remove any standalone ::: markers that might be left
    cleaned_markdown = re.sub(r'^\s*:::\s*$', '', cleaned_markdown, flags=re.MULTILINE)

    # Log if notes were removed (helpful for debugging)
    if markdown != cleaned_markdown:
        notes_count = len(re.findall(pattern, markdown, re.MULTILINE | re.DOTALL))
        log.debug(f"Removed {notes_count} speaker notes block(s) from {page.file.src_path}")

    return cleaned_markdown