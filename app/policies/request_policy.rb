class RequestPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    @record.customer == @user || @user.class.name == "Supplier" ||
      @user.class.name == "Broker"
  end

  def create?
    @user.class.name == "Customer" || @user.class.name == "Broker"
  end

  def new?
    @user.class.name == "Customer" || @user.class.name == "Broker"
  end

  def update?
    @record.customer == @user || @user.class.name == "Broker"
  end

  def edit?
    @record.customer == @user || @user.class.name == "Broker"
  end

  def destroy?
    @record.customer == @user || @user.class.name == "Broker"
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
