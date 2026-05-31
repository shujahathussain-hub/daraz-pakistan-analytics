import os
import subprocess
import sys

scripts = [
    "Python/01_data_cleaning.py",
    "Python/02_exploratory_data_analysis.py",
    "Python/03_business_analysis.py",
    "Python/04_forecasting.py",
    "Python/05_churn_prediction.py"
]

print("==================================================")
print("STARTING DARAZ PAKISTAN DATA ANALYTICS PIPELINE")
print("==================================================")

for script in scripts:
    print(f"\n--> Running {script}...")
    result = subprocess.run([sys.executable, script], capture_output=True, text=True)
    if result.returncode == 0:
        print(result.stdout)
        print(f"SUCCESS: {script} finished.")
    else:
        print(f"ERROR: {script} failed.")
        print(result.stderr)
        sys.exit(1)

print("\n==================================================")
print("PIPELINE EXECUTED SUCCESSFULLY: ALL SCRIPTS RUN")
print("==================================================")
