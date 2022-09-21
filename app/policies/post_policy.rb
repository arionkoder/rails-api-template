class PostPolicy < ApplicationPolicy
  def update?
    creator_and_not_published?
  end

  def destroy?
    creator_and_not_published?
  end

  private

  def creator_and_not_published?
    !record.published? && record.user == user
  end
end
