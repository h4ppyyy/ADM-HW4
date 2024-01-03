# Set the input file path
input_file="vodclickstream_uk_movies_03.csv"

# 1. What is the most-watched Netflix title?
# Extract Netflix titles, count occurrences, and find the most-watched title
most_watched_title=$(awk -F ',' '{print $4}' "$input_file" | sort | uniq -c | sort -nr | awk 'NR==1 {$1=""; print $0}' | sed 's/^ *//')
echo "Most watched title: $most_watched_title"

# 2. The average time of subsequent clicks on Netflix.com
# Filter rows with duration >= 0.0, calculate average duration, and convert to minutes
filtered_file="filtered_duration.csv"
awk -F ',' '{ if ($3 >= 0.0) print $0 }' "$input_file" > "$filtered_file"
avg_duration=$(awk -F ',' '{sum += $3} END {print sum/NR}' "$filtered_file")
avg_min=$(awk -v avg_duration="$avg_duration" 'BEGIN { avg_min = avg_duration / 60; printf "%.2f\n", avg_min }')
echo "Average duration of subsequent clicks: $avg_min minutes"

# 3. ID of the user that has spent the most time on Netflix
# Group by user_id, sum duration, sort by total duration, and find the user with the highest total
sorted_users_file="sorted_users.txt"
awk -F ',' 'NR>1 { sum[$NF] += $3 } END { for (i in sum) print i, sum[i] }' "$filtered_file" | sort -k2,2nr > "$sorted_users_file"
high_time_user=$(awk 'NR==1 {print $1}' "$sorted_users_file")
echo "The user that has spent the most time on Netflix: $high_time_user"

# Clean up temporary files
rm "$filtered_file" "$sorted_users_file"
