import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

program_add = [
"0", # program starts at address 1
    "00000000000000000000000110011110_0000000000000000_0_000_000_000_000101",
    "00000000000000000000000010011110_0000000000000000_0_001_011_000_000101",
    "00000000000000000000000000000000_0000000000000000_0_010_000_001_000000",
    "00000000000000000000000000000000_0000000000000000_0_010_111_010_000111",

]
async def write(dut, value):
    global cycles
    value = value.replace("_","")
    for byte in range(0,8):
        dut._log.info("writing")

        dut.uio_in.value = int(value[byte*8:byte*8+8],2)

        await ClockCycles(dut.clk, 1)
        cycles+=1
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
cycles = 0
async def read(dut):
    global cycles
    data = 0
    addr = 0
    # await ClockCycles(dut.clk, 1)
    cycles+=1
    for i in range(0,8):


        dut._log.info("reading...")
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
        addr += int(dut.uo_out.value) << (i*8)
        data += int(dut.uio_out.value) << (i*8)
        print(i)
        
        await ClockCycles(dut.clk, 1)
        cycles+=1
    return data,addr
def prepareprogram(program):
    pr2 = []
    for programline in program:
        pr2.append(programline.replace("_",""))
    return pr2
async def testprogram(dut,program,result=158+158+256,maxi=100):
    global cycles
    done = False
    dut._log.info("Test project behavior")

    i = 0
    while not done and i < maxi:
        await ClockCycles(dut.clk,1)
        cycles +=1
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
        data,addr = await read(dut)

        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
        readwrite = int( dut.uo_out.value )== 1
        dut._log.info(str(data) + " addr: " + str(addr) + "rw:" + str(readwrite))
        if (result == data and readwrite == 1):
            dut._log.info("right" + str( data))
            assert True
            done = True
            return
        if addr >= len(program):
            assert False

        dut._log.info("writing")
        await write(dut, program[addr])
        

        
        i+=1
        await ClockCycles(dut.clk,1)
        cycles += 1
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
        dut._log.info("cycl"+str(cycles))
        cycles = 0
    assert False

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 1, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    for i in range(90):

        await ClockCycles(dut.clk, 1)
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
    dut.rst_n.value = 1
    for i in range(37):

        await ClockCycles(dut.clk, 1)
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))

    print()


    # Set the input values you want to test

    await testprogram(dut,program_add)
    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
