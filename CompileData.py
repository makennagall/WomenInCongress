#!/usr/bin/env python3

import sys

def main():
    if len(sys.argv) != 6:
        print("Correct Command Line Input Format:")
        print("\tBaseFileName FileExtension StartCongress EndCongress OutputFileName")
        sys.exit("Incorrect Number of Command Line Arguments")
    BaseFileName = sys.argv[1]
    FileExtension = sys.argv[2]
    StartCongress = sys.argv[3]
    EndCongress = sys.argv[4]
    CompiledFile = sys.argv[5]
    Output = open(CompiledFile + FileExtension, 'w')
    for Congress in range(int(StartCongress), int(EndCongress)+1):
        currFile = open(BaseFileName + str(Congress) + FileExtension, 'r')
        for line in currFile:
            Output.write(line)
        currFile.close()

#Execute Main:
if __name__ == '__main__':
    main()
