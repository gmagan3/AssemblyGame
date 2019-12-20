# AssemblyGame
Problem Definition

    Implement and test your own ReadVal and WriteVal procedures for unsigned integers. Your ReadVal implementation will accept a numeric string input from the keyboard and will compute the corresponding integer value. For example, if the user entered a string "1234" then the numeric value 1234 would be computed (and stored in the requested OFFSET). WriteVal will perform the opposite transformation. For example, WriteVal can accept a 32 bit unsigned int and display the corresponding ASCII representation on the console (e.g. if WriteVal receives the value 49858 then the text "49858" will be displayed on the screen).
    Implement macros getString and displayString. The macros may use Irvine’s ReadString to get input from the user, and WriteString to display output.
    Additional details are as follows:
        getString should display a prompt, then get the user’s keyboard input into a memory location.
        displayString should print the string which is stored in a specified memory location.
        ReadVal should invoke the getString macro to get the user’s string of digits. It should then convert the digit string to numeric, while validating the user’s input.
        WriteVal should convert a numeric value to a string of digits and invoke the displayString macro to produce the output.

    Once you have implemented the two procedures you will then demonstrate their usage by creating a small test program. The program will get 10 valid integers from the user and store the numeric values into an array. The program will then display the list of integers, their sum, and the average value of the list.
