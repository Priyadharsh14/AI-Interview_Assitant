FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY requirements-prod.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements-prod.txt

COPY app/ ./app/
COPY core/ ./core/
COPY infrastructure/ ./infrastructure/
COPY config/ ./config/

RUN mkdir -p /app/data/chroma_db /app/data/uploads

ENV STREAMLIT_SERVER_PORT=7860
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0
ENV STREAMLIT_SERVER_HEADLESS=true
ENV STREAMLIT_CLIENT_SHOW_SIDEBAR_NAVIGATION=false
ENV STREAMLIT_SERVER_MAX_UPLOAD_SIZE=10
ENV STREAMLIT_SERVER_ENABLE_XSRF_PROTECTION=false
ENV CHROMA_PERSIST_DIRECTORY=/app/data/chroma_db
ENV UPLOAD_DIRECTORY=/app/data/uploads
ENV DATA_DIRECTORY=/app/data

EXPOSE 7860

CMD ["streamlit", "run", "app/main.py", "--server.port=7860", "--server.address=0.0.0.0", "--server.headless=true", "--server.enableXsrfProtection=false"]
