# Granite Bonus — Time Series (TTM) — Solution

Compute trailing 12-month sums and plot.

```python
import pandas as pd
import matplotlib.pyplot as plt
df = pd.DataFrame({
    "month": pd.date_range("2022-01-01", periods=24, freq="MS"),
    "revenue": [100,120,90,110,130,140,150,160,170,180,190,200]*2
}).set_index("month")
df["ttm"] = df["revenue"].rolling(12).sum()
df[["revenue","ttm"]].plot(title="Revenue vs TTM"); plt.show()
```
