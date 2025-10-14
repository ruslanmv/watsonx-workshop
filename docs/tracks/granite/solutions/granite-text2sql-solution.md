# Granite Bonus — Text-to-SQL — Solution

Provide schema as context, request SQL-only, then validate before execution.

**Prompt**

```
You are a SQL assistant. Use ONLY this schema:
customers(id, name, region)
orders(id, customer_id, amount, created_at)

Question: Total sales by region in 2024?
Return only SQL.
```
