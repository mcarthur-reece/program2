rails g model Event \
  title:string \
  description:text \
  location:string \
  event_date:date \
  start_time:time \
  end_time:time \
  required_number_of_volunteers:integer \
  status:integer