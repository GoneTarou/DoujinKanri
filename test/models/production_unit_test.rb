require "test_helper"

class ProductionUnitTest < ActiveSupport::TestCase
  def build_production_unit(attributes = {})
    defaults = {
      work: works(:one),
      position: 1
    }

    ProductionUnit.new(defaults.merge(attributes))
  end

  test "有効な制作対象を作成できる" do
    production_unit = build_production_unit

    assert_predicate production_unit, :valid?
  end

  test "順番が0の場合は無効である" do
    production_unit = build_production_unit(position: 0)

    assert_not production_unit.valid?
    assert production_unit.errors[:position].present?
  end

  test "順番が1000の場合は無効である" do
    production_unit = build_production_unit(position: 1000)

    assert_not production_unit.valid?
    assert production_unit.errors[:position].present?
  end

  test "同じ作品内で同じ順番の制作対象は無効である" do
    ProductionUnit.create!(
      work: works(:one),
      position: 1
    )

    production_unit = build_production_unit(position: 1)

    assert_not production_unit.valid?
    assert production_unit.errors[:position].present?
  end
end
