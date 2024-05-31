# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

program_add = [
    int("000101_000_000_000_0_0000000010011110"[::-1],2),
    int("000101_001_000_000_0_0000000010011110"[::-1],2),
    int("000000_001_000_000_0_0000000000000000"[::-1],2),
    int("001000_001_000_000_0_0000000000000000"[::-1],2),

]
async def writenumber(dut,value):
    data = value.to_bytes(4, 'big')
    for byte in reversed(data):

        dut.uio_in.value = int(byte)
        await ClockCycles(dut.clk, 1)
async def read(dut):
    data = 0
    addr = 0
    for i in reversed( range(0,4)):
        await ClockCycles(dut.clk, 1)
        dut._log.info("reading...")
        addr += int(dut.uo_out.value) << (i*8)
        data += int(dut.uio_out.value) << (i*8)
    return data,addr
async def testprogram(dut,program,result=158+158):
    done = False
    dut._log.info("Test project behavior")
    dut._log.info("Test project behavior")
    while not done:
        await ClockCycles(dut.clk, 1)
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
        data,addr = await read(dut)

        dut._log.info(str(data) + " addr: " +str(addr))
        if addr >= len(program):
            assert False
            done = True

        if (result == data and dut.uio_oe.value == 1):
            print("right",data)
            assert True
            done = True
            return
        await writenumber(dut,program[addr])
@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    for i in range(10):

        await ClockCycles(dut.clk, 1)
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
    dut.rst_n.value = 1
    for i in range(1):

        await ClockCycles(dut.clk, 1)
        dut._log.info("state:" + str(dut.uo_out) +" " + str(dut.uio_in) + " "+  str(dut.uio_out))
    print()


    # Set the input values you want to test

    await testprogram(dut,program_add)
    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
