###NOTE: This script only focus on the ERROR log level ONLY

import pandas as pd  #for data manipulation
from collections import Counter #for counting occurrences
import re

log_file_path = 'system_log.log'

# Read the log file
log_entries = []
with open(log_file_path, 'r') as file:
    for line in file:
        match = re.match(r"(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) (\w+) (.+)", line.strip())
        if match:
            timestamp, level, message = match.groups()
            log_entries.append({'timestamp': timestamp, 'level': level, 'message': message})

# Serialize the log data into a DataFrame
df = pd.DataFrame(log_entries, columns=['timestamp', 'level', 'message'])
df["timestamp"] = pd.to_datetime(df["timestamp"])

# Count the number of errors in last 30 seconds
error_counts = Counter(df[df['level'] == 'ERROR']['timestamp'].dt.floor('30s'))
threshold = 3
# finding the timestamps where error count exceeds threshold
error_spikes = [time for time, count in error_counts.items() if count > threshold]
#filter logs with anomalies
anomalies = df[df['timestamp'].dt.floor('30s').isin(error_spikes)]

# detect error spikes and send notification
for time, count in error_counts.items():
    if count > threshold:
        print(f"ALERT: High number of errors detected at {time}. Count: {count}")

# show logs with anomalies
print("Logs with anomalies:")
anomalies = df[df['level'] == 'ERROR']
print(anomalies)
