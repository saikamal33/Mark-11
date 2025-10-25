import pandas as pd  #for data manipulation
from sklearn.ensemble import IsolationForest #for anomaly detection
import numpy as np

log_file_path = 'system_log.log'
with open(log_file_path, 'r') as file:
    logs = file.readlines()

data = []
for log in logs:
    parts = log.strip().split(' ', 3)  # Assuming log format: "timestamp level message"
    if len(parts) < 4:
        continue
    timestamp = parts[0] + ' ' + parts[1]
    level = parts[2]
    message = parts[3]
    data.append((timestamp, level, message))

# Read the log file

# Serialize the log data into a DataFrame
df = pd.DataFrame(data, columns=['timestamp', 'level', 'message'])
df['timestamp'] = pd.to_datetime(df['timestamp'])

# Assign numeric scores to log levels
level_mapping = {'DEBUG': 1, 'INFO': 2, 'WARNING': 3, 'ERROR': 4, 'CRITICAL': 5}
df['level_score'] = df['level'].map(level_mapping)

# Adding message length as a feature
df['message_length'] = df['message'].apply(len)

# AI model for anomaly detection
model = IsolationForest(contamination=0.1, random_state=42)
df['anomaly_score'] = model.fit_predict(df[['level_score', 'message_length']])

# mark anomalies in a readable format
df['is_anomaly'] = df['anomaly_score'].apply(lambda x: 'Anomaly' if x == -1 else 'Normal')

# print only detected anomalies
anomalies = df[df['is_anomaly'] == 'Anomaly']
print("\n ** Detected Anomalies **\n", anomalies)
