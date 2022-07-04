Rails.application.routes.draw do
  mount Authorization::Engine => "/authorization"
end
