import serial           # import the module
import struct
import time


#For linux users
#dmesg | grep tty
ComPort = serial.Serial('/dev/ttyUSB1') # for linux users
#sudo chmod a+rw /dev/ttyUSB1
# ComPort = serial.Serial('COM5') # for windows users- check from device manager

ComPort.baudrate = 115200 # set Baud rate to 9600
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1

## allowing for matrix input, use file handling for easiness of inputs


# ----------------------------------------------
mat = [[1,2,3,4], [5,6,7,8], [9,10,11,12], [13,14,15,16]]
print(mat)
def isValid(x,y):
    if(x < 0 or y < 0):
        return False
    elif(x > 3 or y > 3):
        return False
    return True


## transferring matrix into bram
for i in range(4):
    col = -1 * i
    row = i
    send_array = [0]
    for j in range(9):
        if(isValid(col+j, row)):
            send_array.append(mat[row][col+j])
        else:
            send_array.append(0)

    for item in send_array:
        ot = ComPort.write(struct.pack('>B', int(item)))    #for sending data to FPGA
        print(f"{item}", end=" ")
        time.sleep(1)
        
    
    print(f"data in the BRAM {i+1}")


# -----------------------------------------------------------------------------

## transferring the matrix, without bram help


# something = 0
# ot = ComPort.write(struct.pack('>B', int(something)))    #for sending data to FPGA
# time.sleep(1)
# print(f"{something}", end=" ")
# ot = ComPort.write(struct.pack('>B', int(something)))    #for sending data to FPGA
# time.sleep(1)
# print(f"{something}", end=" ")
# ot = ComPort.write(struct.pack('>B', int(something)))    #for sending data to FPGA
# time.sleep(1)
# print(f"{something}", end=" ")
# ot = ComPort.write(struct.pack('>B', int(something)))    #for sending data to FPGA
# time.sleep(1)
# print(f"{something}", end=" ")
# print(f"stuff going in the 0th clock cycle")
# time.sleep(1)

# for i in range(7):
#     row = i
#     col = 0
#     a = 0
#     b = 0
#     c = 0
#     d = 0
#     if(isValid(col, row)):
#         a = mat[row][col]

#     if(isValid(col+1, row-1)):
#         b = mat[row-1][col+1]

#     if(isValid(col+2, row-2)):
#         c = mat[row-2][col+2]
    
#     if(isValid(col+3, row-3)):
#         d = mat[row-3][col+3]

#     ot = ComPort.write(struct.pack('>B', int(a)))    #for sending data to FPGA
#     time.sleep(1)
#     print(f"{a}", end=" ")

#     ot = ComPort.write(struct.pack('>B', int(b)))    #for sending data to FPGA
#     time.sleep(1)
#     print(f"{b}", end=" ")

#     ot = ComPort.write(struct.pack('>B', int(c)))    #for sending data to FPGA
#     time.sleep(1)
#     print(f"{c}", end=" ")

#     ot = ComPort.write(struct.pack('>B', int(d)))    #for sending data to FPGA
#     time.sleep(1)
#     print(f"{d}", end=" ")

#     print(f"stuff going in the {i+1}th clock cycle")
#     time.sleep(1)


    
ComPort.close()         # Close the Com port



# while True:
#     x= input()
#     if x == 'q':
#         break
#     else:
#         ot = ComPort.write(struct.pack('>B', int(x)))    #for sending data to FPGA
#         print(f"Sent {x} over UART")

#     time.sleep(0.3)

# ComPort.close()         # Close the Com port
