## 표현 벡터 & 연산자 벡터
def rep_vector(text):
    data = []  # 암호화할 데이터 영역
    data_position = []  # 위치를 저장할 리스트
    
    op_position = []  # 위치를 저장할 리스트
    op_ascii = []  # ASCII(94진법) 값을 저장할 리스트
    filtered_op_position = []  # 괄호가 아닌 연산자의 위치
    filtered_op_ascii = []  # 괄호가 아닌 연산자의 ASCII 값
    
    index = 0  
    adjustments = []  # 인덱스 조정 정보를 저장할 리스트
    
    while index < len(text): 
        char = text[index]
        if char.isalpha():  
            # Data 영역
            data.append(char)
            data_position.append(index + 1)
            index += 1
        elif char.isdigit():
            start_index = index
            # 연속된 숫자 처리
            while index < len(text) and text[index].isdigit():
                index += 1
            # substring으로 숫자 가져오기
            num_str = text[start_index:index]
            data.append(num_str)
            data_position.append(start_index + 1)  # 첫 숫자 위치
            
            # 숫자의 길이 및 위치 저장
            adjustments.append((start_index + 1, len(num_str)))  # (위치, 길이)
            continue  # 다음 문자로 넘어감
        else:
            # 괄호 및 연산자
            ascii_val = from_base94(char)
            op_position.append(index + 1)  # 위치
            op_ascii.append(ascii_val)  # ASCII 값 추가
            
            # 연산자 Algorithm # 연산자 영역
            if ascii_val not in (7, 8):
                filtered_op_position.append(index + 1)
                filtered_op_ascii.append(ascii_val)
            index += 1  # 다음 문자 이동

    # 인덱스 조정
    for pos, length in adjustments:
        # 각 리스트의 인덱스를 한 번에 조정
        data_position = list(map(lambda x: x - (length - 1) if x > pos else x, data_position))
        filtered_op_position = list(map(lambda x: x - (length - 1) if x > pos else x, filtered_op_position))
        op_position = list(map(lambda x: x - (length - 1) if x > pos else x, op_position))

    op_p = f"({' '.join(map(str, op_position))})"
    op_a = f"({' '.join(map(str, op_ascii))})"
    print("나머지 위치 정보 임시 생성:", op_p, op_a)
    
    data_op = f"({' '.join(map(str, data_position))})"  # 데이터 영역
    pairs = find_pairs(tuple(op_position), tuple(op_ascii))  # 괄호 영역
    op = f"({' '.join(map(str, filtered_op_position))})"  # 연산자 영역
    
    filtered_op_a = f"[{' '.join(map(str, filtered_op_ascii))}]" # 연산자 벡터
    
    return data_op + pairs + op, filtered_op_a, data

# 괄호 Algorithm
def find_pairs(positions, ascii_values):
    pairs = []
    open_stack = []  # 여는 괄호 위치
    temp_pairs = []  # 매칭된 괄호 pair 

    for pos, ascii_val in zip(positions, ascii_values):
        if ascii_val == 7:  # 여는 괄호
            open_stack.append(pos)
        elif ascii_val == 8 and open_stack:  # 닫는 괄호
            start_pos = open_stack.pop()  
            temp_pairs.append((start_pos, pos)) 

    pairs = sorted(temp_pairs, key=lambda x: x[0])

    return ''.join(f"({start} {end})" for start, end in pairs)

## ASCII(94진법)
def from_base94(base94_str):
    base94_chars = ''.join(chr(i) for i in range(33, 127))
    base = len(base94_chars)
    values = {char: idx for idx, char in enumerate(base94_chars)}
    num = sum(values[char] * (base ** idx) for idx, char in enumerate(reversed(base94_str)))
    return num