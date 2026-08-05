# RailsIAM

JWT • RBAC • PBAC • IAM • Roles • Permissions

RailsIAM is a database-driven Identity & Access Management (IAM) engine for your Rails applications. It follows an endpoint-first authorization model where permissions are treated as data, not code. Roles and permission assignments are stored in the database, allowing access control to evolve without changing authorization logic. RailsIAM includes an optional JWT authentication implementation for applications that need it, while its authorization layer works with Devise or any authentication system capable of providing the authenticated user.

## Why RailsIAM exists?

RailsIAM is not trying to reinvent authentication or authorization.

The Rails ecosystem already has excellent solutions for these problems. You can build authentication yourself, use Devise, write your own authorization layer, or choose from several existing gems.

RailsIAM exists for a different reason: **to save your time from rebuilding the same foundation every time.**

Every Rails application eventually needs the same building blocks:

- Who is the authenticated user?
- What roles does this user have?
- What permissions should they have?
- Which controller actions can they access?
- How do we manage access changes without touching application code or redeploying the application?
- Who gives permissions to whom?

RailsIAM gives you that foundation out of the box, so team can focus on building business features instead of spending **_another sprint works_** wiring authentication, roles, permissions, database relationships, authorization checks, auditing and error handling.

## How to use it?

Most Rails applications eventually need to answer one important question:

> **_"Is this authenticated user allowed to perform this action?"_**

With RailsIAM, authorization is declared at the point where requests enter application — controller actions. There are no policy classes to maintain, no authorization logic scattered across models, and no condition-heavy permission checks inside controllers.

Once roles and permissions are stored in the database, protecting an action becomes as simple as declaring who can access it.

Whether team building an API-only application or a traditional Rails application with server-rendered views, RailsIAM keeps authorization rules explicit, centralized, and independent from authentication strategy.

### Role-based authorization

Allow administrators to access every action in the controller.

```ruby
class UsersController < ApplicationController

  # admin role can access to *all* the actions
  authorize roles: :admin

end
```

---

### Permission-based authorization

Protect a single endpoint using a permission stored in the database. No matter what your role is.

```ruby
class UsersController < ApplicationController

  # people who has "user:show" permission can access to show action
  authorize permissions: "user:show", only: :show

  def show; end
end
```

Some endpoints should remain publicly accessible while the rest of the controller requires authorization.

```ruby
class ProductsController < ApplicationController

  authorize permissions: "product:manage", except: [:index, :show]

  def index; end      # Public
  def show; end       # Public
  def create; end     # Requires product:manage
end
```

---

### Role + Permission

Require both a specific role **and** a permission.

This is useful when only members of a department should be able to perform an operation, even if another role happens to own the same permission.

```ruby
class UsersController < ApplicationController
  # admin and manager roles can access to all the action
  authorize roles: [:admin, :manager]
  # sales role can only access to :show
  authorize roles: :sales, permissions: "user:show", only: :show

  def show; end
end
```

---

### Convention over configuration

Rails IAM can infer the required permission directly from the controller and action.

```ruby
class UsersController < ApplicationController

  authorize_resource
end
```

The following permissions will automatically be checked:

```
| Controller Action | Required Permission |
  (UsersController) |
| ----------------- | ------------------- |
| index             | user:index          |
| show              | user:show           |
| create            | user:create         |
| update            | user:update         |
| destroy           | user:destroy        |
| send_invite       | user:send_invite    |
```

Namespaced controllers are also supported.

```text
Admin::Users::CustomersController#show -> admin_users_customer:show
```

---

### Skip authorization

Skip authorization for an entire controller.

```ruby
skip_authorization
```

Or only for selected actions.

```ruby
skip_authorization only: :sign_up
```

More example [here](/wiki/Authorization-Rules).

---

That's it.

👉 No policy objects.

👉 No permission checks inside your controller actions.

👉 No authorization logic inside models.

Our controllers and models stay focused on handling requests and business logic of our application, while RailsIAM takes care of deciding **who is allowed to access them**.

## So what RailsIAM brings to us?

- **Production-ready out of the box** — Install a single gem to get jwt based authentication and authorization with Role-Based Access Control (RBAC) and Permission-Based Access Control (PBAC).

- **Authorization where it belongs** — Declare access rules at the controller level, where requests enter application. Keep controllers focused on business logic and models focused on persistence.

- **No authorization logic scattered across your application** — No policy classes, no permission checks inside controller actions, and no complex conditional logic in models.

- **Permissions are data, not code** — Roles and permissions live in the database, allowing administrators to grant, revoke, or reorganize access without changing application code.

- **Change permissions without deployments** — Updating who can access an endpoint doesn't require modifying Ruby files or redeploying the application.

- **Convention over configuration** — Automatically infer permissions from controller and action names with `authorize_resource`, while still allowing explicit rules whenever needed.

- **Authentication is optional** — Use the built-in JWT authentication for API applications, or keep your existing authentication solution such as Devise. RailsIAM's authorization layer works independently and supports both API-only and traditional Rails (ERB/HTML) applications.

- **Highly configurable** — Customize model names, current user methods, JWT settings, cookies, cache, localization, error messages, and other behaviors to fit your application's conventions.

## Continue Reading

- [Getting Started](/wiki/Getting-Started)
- [Authentication](/wiki/Authentication)
- [Authorization](/wiki/Authorization)
- [Authorization Rules](/wiki/Authorization-Rules)
- [Configuration](/wiki/Configuration)
- [Testing controller](/wiki/Testing-Controller)

## Contributing

Please read the [Contributing Guidelines](https://github.com/salmanx/rails_iam/blob/main/CONTRIBUTING.md).
