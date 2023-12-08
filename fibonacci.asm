    .data
    .text
    .globl main

main:
    li $t0, 0         # Initialize first number of the sequence to 0
    li $t1, 1         # Initialize second number of the sequence to 1
    li $t2, 10        # Set the counter for 10 iterations (for 11th term)

loop:
    add $t3, $t0, $t1 # Add the last two numbers
    move $t0, $t1     # Move the second number to the first number's place
    move $t1, $t3     # Store the sum as the new second number

    sub $t2, $t2, 1   # Decrement the loop counter
    bgtz $t2, loop    # If counter > 0, loop again

    # Now, $t3 contains the 11th term
    move $a0, $t3     # Move the result to $a0 for printing (if needed)
    li $v0, 1         # System call for print_int
    syscall           # Make the system call

    li $v0, 10        # System call for exit
    syscall           # Exit the program
