from flask import Flask
import os
import psycopg2

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask backend through Nginx!\n"

@app.route("/db")
def db():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "db"),
            database=os.getenv("DB_NAME", "task2db"),
            user=os.getenv("DB_USER", "task2user"),
            password=os.getenv("DB_PASSWORD", "task2pass"),
        )
        conn.close()
        return "Database connection: OK\n"
    except Exception as e:
        return f"Database connection failed: {e}\n", 500

app.run(host="0.0.0.0", port=5000)
