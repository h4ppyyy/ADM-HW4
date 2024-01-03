def highest_score(S, marks):
    # Base case: If there are no more exams, return the current score
    if not marks:
        return S
    
    # Try taking each exam and recursively calculate the highest score
    max_score = float('-inf')
    for p in marks:
        # For "easy" exams
        if p < S:
            new_score = highest_score(p, [x + S - p for x in marks if x != p])
        # For "hard" exams
        else:
            new_score = highest_score(p, [x - p + S for x in marks if x != p])
        
        # Update the maximum score
        max_score = max(max_score, new_score)
    
    return max_score

# Input reading
initial_score = int(input())
exam_marks = list(map(int, input().split()))

# Calculate and print the result
result = highest_score(initial_score, exam_marks)
print("The highest score Federico could get is:", result)
