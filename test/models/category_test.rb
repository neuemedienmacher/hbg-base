require_relative '../test_helper'

describe Category do
  let(:category) { Category.new }

  subject { category }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_uniqueness_of :name }
      it 'should have a section filter' do
        category.expects(:validate_section_filter_presence)
        category.save
      end
      it 'should have the same section filter as the parent' do
        category.expects(:validate_section_filters_with_parent)
        category.save
      end
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_and_belong_to_many :offers }
      it { subject.must have_and_belong_to_many :section_filters }
      it { subject.must have_many :organizations }
    end
  end

  describe 'methods' do
    describe '#name_with_optional_asterisk' do
      it 'should return name with asterisk for a main category' do
        category.assign_attributes icon: 'x', name: 'a'
        category.name_with_optional_asterisk.must_equal 'a*'
      end
      it 'should return name without asterisk for a non-main category' do
        category.name = 'a'
        category.name_with_optional_asterisk.must_equal 'a'
      end
    end
    describe '#validate_section_filter_presence' do
      it 'should fail when there is no section filter' do
        category.expects(:fail_validation).with :section_filters,
                                                'needs_section_filters'
        category.validate_section_filter_presence
      end
      it 'should succeed when there is at least one section filter' do
        category = categories(:main1)
        category.expects(:fail_validation).never
        category.validate_section_filter_presence
      end
    end
    describe '#validate_section_filters_with_parent' do
      it 'should fail when the parent does not have the section filter' do
        parent = categories(:main1)
        category = categories(:sub1)
        section_filter = filters(:refugees)
        category.expects(:fail_validation).with :section_filters,
                                                'parent_needs_same_section_fil'\
                                                'ter',
                                                parent_name: parent.name,
                                                filter_name: section_filter.name
        category.validate_section_filters_with_parent
      end
      it 'should succeed when the parent has the same section filter' do
        category = categories(:sub2)
        category.expects(:fail_validation).never
        category.validate_section_filters_with_parent
      end
      it 'should succeed on main categories (no parent)' do
        category = categories(:main1)
        category.expects(:fail_validation).never
        category.validate_section_filters_with_parent
      end
    end
  end
end
