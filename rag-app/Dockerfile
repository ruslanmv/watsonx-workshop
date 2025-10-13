FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
ENV PYTHONPATH=/app
EXPOSE 8001
CMD ["uvicorn", "api.server:app", "--host", "0.0.0.0", "--port", "8001"]
