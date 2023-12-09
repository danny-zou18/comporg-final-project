timescale 1 ns/ 1 ps

module cache (
    input clk,
    input reset, 
    // find data
    input find, 
    input [7:0] key, 
    output reg match_found, 
    output reg [7:0] value ,
    // update data
    input update, 
    input [7:0] update_key, 
    input [7:0] update_value
);
    localparam words = 8;
    logic [(words16)-1:0] data_vec ;

    // find logic 
    always@(posedge clk) begin
        if (reset) begin
            match_found <= 0;
            value <= 0;
        end else begin 
            match_found <= 0;
            value <= 0;
            for (int i = (words); i >0 ; i--) begin
                if (find) begin
                    if (data_vec[(i16)-1 -:8] == key) begin
                        match_found <= 1;
                        value <= data_vec[(i16)-9 -:8];
                    end
                end
            end
        end
    end
    // update logic 
    always@(posedge clk) begin
        if (reset) begin
            for (int i = 1; i <(words+1) ; i++) begin
                data_vec[(i16)-1 -:8] <= i; // some default here
                data_vec[(i16)-9 -:8] <= i+50; // some default here
            end
            $display("INIT-CACHE is %x",data_vec);
        end else begin
            if (update) begin
                data_vec[(words16)-1 -:(words16)] <= {data_vec[((words-1)16)-1 -:((words-1)*16)], update_key, update_value};
            end
        end
    end
endmodule