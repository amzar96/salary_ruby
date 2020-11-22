require "sinatra"
require "./generate_slip"
require "./firebase"
require "date"
require "erb"

current_time = DateTime.now

set :show_exceptions, false
set :protection, :except => [:json_csrf]

get "/" do
  @hello = "Welcome to Staff Tax Calculator!"
  erb :index
end

get "/staff/new" do
  erb :new
end

post "/staff/add" do
  fb = FirebaseAuth.new()
  latest_update = current_time.strftime "%d/%m/%Y %H:%M"
  input_name = params["name"]
  input_gross = params["salary"]
  input_id = params["id"]
  input_gross = Float(input_gross)

  name, gross, tax, net = generate_monthly_payslip input_name, input_gross

  data = { :name => input_name, :salary => input_gross, :monthly_tax => tax[1..-1], :latest_update => latest_update }

  response = fb.set(path = "staff/#{input_id}", data = data)
  parsed = JSON.parse(response.raw_body)

  if response.code == 200
    @staff_name = input_name
    @staff_id = input_id
    @staff_tax = tax
    @update_time = latest_update
    @staff_gross = gross
    erb :success_add
  else
    content_type :json
    {
      "status": response.code,
      "message": "Error adding #{parsed["name"]}",
    }.to_json
  end
end

post "/staff/view/update" do
  fb = FirebaseAuth.new()
  latest_update = current_time.strftime "%d/%m/%Y %H:%M"
  input_name = params["name"]
  input_gross = params["salary"]
  input_id = params["id"]
  input_gross = Float(input_gross)

  name, gross, tax, net = generate_monthly_payslip input_name, input_gross

  data = { :name => input_name, :salary => input_gross, :monthly_tax => tax[1..-1], :latest_update => latest_update }

  response = fb.set(path = "staff/#{input_id}", data = data)
  parsed = JSON.parse(response.raw_body)

  if response.code == 200
    @name = name
    @id = input_id
    @gross = gross
    @tax = tax
    @latest_update = latest_update
    erb :view_staff
  else
    content_type :json
    {
      "status": response.code,
      "message": "Error adding #{parsed["name"]}",
    }.to_json
  end
end

get "/staff/update/:id" do
  # automatically update calulcation
  fb = FirebaseAuth.new()
  latest_update = current_time.strftime "%d/%m/%Y %H:%M"

  input_id = params["id"]
  response = fb.get("staff/#{input_id}")
  parsed = JSON.parse(response.raw_body)

  input_name = parsed["name"]
  input_gross = parsed["salary"]
  input_gross = Float(input_gross)

  name, gross, tax, net = generate_monthly_payslip input_name, input_gross

  update_data = fb.update(path = "staff/#{input_id}", data = { :name => name, :salary => gross[1..-1], :monthly_tax => tax[1..-1], :latest_update => latest_update })

  content_type :json
  { "employee_name": "#{name}",
    "gross_monthly_income": "#{gross}",
    "monthly_income_tax": "#{tax}",
    "net_monthly_income": "#{net}",
    "update_data_status": update_data.code }.to_json
end

get "/staff/view/all" do
  fb = FirebaseAuth.new()

  input_id = params["id"]
  response = fb.get_all()
  parsed = JSON.parse(response.raw_body)
  @all_data = parsed
  erb :all
end

get "/staff/all" do
  fb = FirebaseAuth.new()

  input_id = params["id"]
  response = fb.get_all()
  parsed = JSON.parse(response.raw_body)
  results = {
    "salary_computations" => [parsed],
  }
  content_type :json
  JSON[results]
end

get "/staff/:id" do
  # automatically update calulcation
  fb = FirebaseAuth.new()

  input_id = params["id"]
  response = fb.get("staff/#{input_id}")
  parsed = JSON.parse(response.raw_body)

  name = parsed["name"]
  gross = parsed["salary"]
  tax = parsed["monthly_tax"]
  latest_update = parsed["latest_update"]

  content_type :json
  { "employee_name": "#{name}",
    "gross_monthly_income": "#{gross}",
    "monthly_income_tax": "#{tax}",
    "latest_update": "#{latest_update}" }.to_json
end

get "/staff/view/:id" do
  fb = FirebaseAuth.new()

  input_id = params["id"]
  response = fb.get("staff/#{input_id}")
  parsed = JSON.parse(response.raw_body)

  name = parsed["name"]
  gross = parsed["salary"]
  tax = parsed["monthly_tax"]
  latest_update = parsed["latest_update"]

  @name = name
  @id = input_id
  @gross = gross
  @tax = tax
  @latest_update = latest_update
  erb :view_staff
end

get "/staff/delete/:id" do
  fb = FirebaseAuth.new()

  input_id = params["id"]
  response = fb.delete("staff/#{input_id}")

  content_type :json
  { "status": response.code,
    "message": "Success delete staff #{input_id}" }.to_json
end

# Error Handling
not_found do
  content_type :json
  {
    "message": "Try again, wrong URL!",
  }.to_json
end
