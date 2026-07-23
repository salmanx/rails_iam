# frozen_string_literal: true

Rails.application.routes.draw do
  sign_in_path  = RailsIam.configuration.authentication.sign_in_path
  sign_out_path = RailsIam.configuration.authentication.sign_out_path
  refresh_token_path = RailsIam.configuration.authentication.refresh_token_path

  if sign_in_path.present?
    post sign_in_path,
         to: "rails_iam/auth#sign_in",
         as: :rails_iam_sign_in
  end

  if sign_out_path.present?
    post sign_out_path,
         to: "rails_iam/auth#sign_out",
         as: :rails_iam_sign_out
  end

  if refresh_token_path.present?
    post refresh_token_path,
         to: "rails_iam/auth#refresh",
         as: :rails_iam_refresh
  end
end
