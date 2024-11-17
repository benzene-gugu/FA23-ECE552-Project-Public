if __name__ == '__main__':
    file_name = 'test4'
    with open('../testcases/'+file_name,'r') as file_in:
        line_count = sum(1 for _ in file_in)
    with open(file_name+'.txt','w') as file_out:
        with open('../testcases/'+file_name,'r') as file_in:
            for _ in range(line_count):
                file_out.write(file_in.readline())
        for _ in range(2 ** 16 - line_count):
            file_out.write('0\n')
