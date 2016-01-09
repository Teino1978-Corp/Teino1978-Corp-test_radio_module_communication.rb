def test_radio_module_communication
 total_reads = 20
 overall_result = "SUCCESS"
  
   # get the current study table first so it can be reset after test
   original_serial_numbers = get_serial_numbers_from_study_table
   # ---------------------------------------------------------------

   # clear out the current study table
   send_set_study_table_command([])

   # set a new study table in the RM to a known value
   motes = (1..350).to_a
   send_serial_numbers_to_study_table(motes)

   # request study table repeatedly and verify it matches what was expected
   total_reads.times do |count|
     serial_numbers = get_serial_numbers_from_study_table

     result = "FAIL"
     if serial_numbers.size == 350
       if ((1..350).reject {|index| serial_numbers.include? index}).size == 0
         result = "SUCCESS"
       else
         overall_result = "FAIL"
       end
     else
       overall_result = "FAIL"
     end

     say "Attempt #{count+1} of #{total_reads} of reading study table from Radio Module...#{result}"
   end

   say ""
   say "Resetting study table to previous value..."

   # clear out the current study table prior to resetting or original values
   send_set_study_table_command([])

   send_serial_numbers_to_study_table(original_serial_numbers)

   say "Radio Module Communication Test: #{overall_result}"
 end
end