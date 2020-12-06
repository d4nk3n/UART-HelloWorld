# UART-HelloWorld

Verilog code to send "Hello World\n" through UART at specified baud rate.

Here is the signal captured with [PulseView](https://sigrok.org/wiki/PulseView):
![](https://raw.githubusercontent.com/d4nk3n/Blog/master/2020-12-uart/uart-send-hello.jpg)

It works fine on Digilent Nexys3 Board, with Xilinx Spartan-6 LX16 FPGA.

NOTE: The synthesizer XST gives several WARNINGS that I haven't handled yet, I'm not sure whether they can be ignored.

I copied some code from https://github.com/jamieiles/uart, with slight modifications.

## Documentation

Main code in `rtl` subdirectory, constraint file for Nexys3 Board in `constraint` subdirectory.

To change the baud rate, modify the parameter `BAUD_RATE` in `uart_hello.v`, by default it's 9600.

The default input clock frequency is 100MHz, you can also change it in `uart_hello.v`. And modify `STRING_SEND` and `STRING_LEN` to send whatever you prefer.

Change `SEND_RATE` in file `send_signal.v` if you want it to send twice or more per second. 

Hold input signal `pause` to pause sending.

## Module Structure

```
uart_hello
 ├─send_signal
 └─uart
    ├─baud_clk
    └─tx
```
