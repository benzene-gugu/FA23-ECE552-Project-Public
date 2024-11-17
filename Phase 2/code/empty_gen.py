if __name__ == '__main__':
    with open('empty.txt', 'w') as file_out:
        for _ in range(2 ** 16):
            file_out.write('0\n')
