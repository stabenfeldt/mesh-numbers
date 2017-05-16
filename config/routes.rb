Rails.application.routes.draw do
  get 'members/total'

  get 'members/worklounge'

  get 'members/fixed'

  get 'members/flex'

  root 'pages#home'
end
