FROM python:3.10-slim-bullseye

ENV PYTHONUNBUFFERED=1

# Install system dependencies (libcairo + compiler + others you may need)
RUN apt-get update && apt-get install -y \
    gcc \
    libcairo2-dev \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only requirements first (to leverage Docker cache)
COPY requirements.txt .

# Install Python dependencies
RUN pip install -v --no-cache-dir -r requirements.txt


# Now copy the rest of your app
COPY . .

# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh

EXPOSE 8080

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8080"]
