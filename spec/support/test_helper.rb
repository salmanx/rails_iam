# frozen_string_literal: true

module TestHelper
  def create_role(name)
    create(:role, name:)
  end

  def create_permission(code)
    create(:permission, code:)
  end

  def assign_role(user:, role:)
    create(
      :user_role,
      user:,
      role:,
    )
  end

  def assign_permission_to_role(role:, permission:)
    create(
      :role_permission,
      role:,
      permission:,
    )
  end

  def grant_permission_to_user(user:, permission:)
    create(
      :user_permission,
      user_id: user.id,
      permission_id: permission.id,
    )
  end

  def deny_permission_from_user(user:, permission:)
    create(
      :user_denied_permission,
      user:,
      permission:,
    )
  end

  def create_role_with_permission(role_name:, permission_code:)
    role = create_role(role_name)

    permission = create_permission(permission_code)

    assign_permission_to_role(
      role:,
      permission:,
    )

    [role, permission]
  end

  def assign_role_with_permission(
    user:,
    role_name:,
    permission_code:
  )
    role, permission =
      create_role_with_permission(
        role_name:,
        permission_code:,
      )

    assign_role(
      user:,
      role:,
    )

    permission
  end

  def grant_user_permission(
    user:,
    permission_code:
  )
    permission =
      create_permission(permission_code)

    grant_permission_to_user(
      user:,
      permission:,
    )

    permission
  end

  def deny_user_permission(
    user:,
    permission:
  )
    deny_permission_from_user(
      user:,
      permission:,
    )
  end
end