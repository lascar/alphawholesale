class TenderLinePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user.class.name == "Customer" || @user.class.name == "Broker"
  end

  def show?
    @user.class.name == "Customer" || @user.class.name == "Broker"
  end

  def create?
    @user.class.name == "Customer" || @user.class.name == "Broker"
  end

  def new?
    @user.class.name == "Customer" || @user.class.name == "Broker"
  end

  def update?
    @record.tender.customer == @user || @user.class.name == "Broker"
  end

  def edit?
    @record.tender.customer == @user || @user.class.name == "Broker"
  end

  def destroy?
    @record.tender.customer == @user || @user.class.name == "Broker"
  end

  def get_names?
    @user.class.name == "Supplier" || @user.class.name == "Broker"
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
