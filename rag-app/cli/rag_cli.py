import argparse, json
from app.chain import build_chain

def main():
    p = argparse.ArgumentParser(description="Ask your grounded RAG agent a question")
    p.add_argument("question", type=str, help="Your question")
    p.add_argument("--show-sources", action="store_true", help="Print retrieved source chunks")
    args = p.parse_args()

    qa = build_chain()
    result = qa.invoke({"query": args.question})

    print("\n=== ANSWER ===\n")
    print(result.get("result", "").strip())

    if args.show_sources:
        print("\n--- sources ---")
        for i, doc in enumerate(result.get("source_documents", []), 1):
            m = doc.metadata or {}
            text = (doc.page_content or "")[:300].replace("\n"," ")
            print(f"[{i}] meta={json.dumps(m)[:300]}  text={text} ...")

if __name__ == "__main__":
    main()
