from flask import Flask, jsonify
import subprocess

app = Flask(__name__)

@app.route("/metrics")
def metrics():
    cpu = subprocess.check_output(
        "top -bn1 | awk '/Cpu\\(s\\)/ {print 100-$8}'",
        shell=True
    ).decode().strip()

    ram = subprocess.check_output(
        "free | awk '/Mem:/ {printf \"%.1f\", ($3/$2)*100}'",
        shell=True
    ).decode().strip()

    disk = subprocess.check_output(
        "df / | awk 'NR==2 {print $5}'",
        shell=True
    ).decode().strip()

    container = subprocess.check_output(
        "docker inspect -f '{{.State.Running}}' task2-backend 2>/dev/null || echo false",
        shell=True
    ).decode().strip()

    return jsonify({
        "cpu_usage_percent": cpu,
        "ram_usage_percent": ram,
        "disk_usage": disk,
        "task2_backend_running": container
    })

app.run(host="0.0.0.0", port=8080)
