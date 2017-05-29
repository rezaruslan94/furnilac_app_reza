json.total_count @parts.count
json.items @parts.paginate(page: params[:page], per_page: 30) do |part|
  json.id part.id
  json.number part.number
end
