# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

program_add = [
    int("00010100000000000000000010011110"[::-1],2),
    int("00010100100000000000000010011110"[::-1],2),
    int("00000000100000000000000000000000"[::-1],2),
    int("00100000100000000000000000000000"[::-1],2),

]
async def writenumber(dut,value):
    data = value.to_bytes(4, 'big')
    for byte in reversed(data):

        dut.uio_in.value = int(byte)
        await ClockCycles(dut.clk, 1)
async def read(dut):
    data = b""
    addr = b""
    for i in range(4):
        await ClockCycles(dut.clk, 1)
        addr += bytes([dut.uo_out.value])
        data += bytes([dut.uio_out.value])
    return reversed(data),reversed(addr)
async def testprogram(dut,program,result=158+158):
    done = False
    while not done:
        await ClockCycles(dut.clk, 1)
        data,addr = read(dut)
        print(data,addr)
        if addr >= len(program):
            assert False
            done = True

        if (result == data and dut.uio_oe.value == 1):
            print("right",data)
            assert True
            done = True
            return
        writenumber(dut,program[addr])
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
    await ClockCycles(dut.clk, 9)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test

    await testprogram(dut,program_add)
    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
