import csv
from datetime import datetime
from collections import defaultdict

def write_to_file(filename, data_chunk, data_header=None):
    with open(filename, 'w', newline='', encoding='utf-8') as new_file:
        writer = csv.writer(new_file)
        if data_header:
            writer.writerow(data_header)
        writer.writerows(data_chunk)    



def split_csv(filename, date_column_name):

    rows_by_month = defaultdict(list)
    header = []
    original_filename, extension = filename.split('.')

    with open(filename, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        header = next(reader)
        # Get the index of the date column
        try:
            date_idx = header.index(date_column_name)
        except ValueError:
            raise Exception(f"Column '{date_column_name}' not found in CSV header.")
         
        for row in reader:
            date_str = row[date_idx]
            try:
                # Parse format like "2023-01-01 15:42:00"
                date = datetime.strptime(date_str, '%Y-%m-%d %H:%M:%S')
                month_key = date.strftime('%Y-%m')
                rows_by_month[month_key].append(row)
            except ValueError:
                print(f"Skipping row with invalid date: {date_str}")


    for month, rows in rows_by_month.items():
        out_filename = f"{original_filename}_{month}.{extension}"
        write_to_file(out_filename, rows, header)
        print(f"Saved {len(rows)} rows to {out_filename}")

split_csv(r'D:/dataset/global_fashion_retail_store/source_crm/transactions.csv', "date")