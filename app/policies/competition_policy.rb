class CompetitionPolicy < ApplicationPolicy
  def index?
  	true
  end

  def show?
  	!user.nil? && user.admin?
  	# to be changed
  end

  def create?
    !user.nil? && user.admin?
  end

  def new?
    create?
  end

  def update?
    !user.nil? && user.admin?
  end

  def edit?
    update?
  end

end