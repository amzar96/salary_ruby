class StaffInfo
  attr_accessor :name, :salary

  def initialize(name = nil, salary = nil)
    @name = name
    @salary = salary
  end
end

def generate_slip(name, gross_salary, tax, net_salary)
  name = "#{name}"
  gross = "$#{gross_salary}"
  tax = "$#{tax}"
  net = "$#{net_salary}"
  return name, gross, tax, net
end

def generate_monthly_payslip(name, salary)
  tax = check_tax salary
  net_salary = salary - tax
  employee = StaffInfo.new(name, salary)
  generate_slip employee.name, employee.salary, tax, net_salary
end

def check_tax(gross_salary)
  $current_gross = 0
  $total_tax = 0

  if gross_salary > 0 && gross_salary <= 20000
    total_tax = gross_salary * 0.0
  elsif gross_salary > 20000 && gross_salary <= 40000
    total_tax = ((20000 * 0.0) + (gross_salary - 20000) * 0.1)
  elsif gross_salary > 40000 && gross_salary <= 80000
    total_tax = ((20000 * 0.0) + (20000 * 0.1) + (gross_salary - 40000) * 0.2)
  elsif gross_salary > 80000 && gross_salary <= 180000
    total_tax = ((20000 * 0.0) + (20000 * 0.1) + (40000 * 0.2) + (gross_salary - 80000) * 0.3)
  elsif gross_salary > 180000
    total_tax = ((20000 * 0.0) + (20000 * 0.1) + (40000 * 0.2) + (100000 * 0.3) + (gross_salary - 180000) * 0.4)
  end

  return total_tax
end
