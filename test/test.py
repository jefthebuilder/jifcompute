# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

program_add = [
    int(reversed("000101_000_000_000_0_0000000010011110"),2),
    int(reversed("000101_001_000_000_0_0000000010011110"),2),
    int(reversed("000000_001_000_000_0_0000000000000000"),2),
    int(reversed("001000_001_000_000_0_0000000000000000"),2),

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
        if addr >= len(program):
            assert False
            done = True

        if (result == data and dut.uio_oe.value == 1):
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
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test


    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
