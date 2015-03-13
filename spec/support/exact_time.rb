def exact_time(date_time)
  # Formating according ISO 8601
  date_time.strftime('%Y-%m-%dT%H:%M:%S.%L%Z')
end
