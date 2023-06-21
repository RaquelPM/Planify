class ApplicationSerializer < ActiveModel::Serializer
  def sampled?
    !detailed?
  end

  def detailed?
    instance_options[:presentation] == :detailed
  end

  class << self
    protected

    def sampled_attributes(*attrs)
      attrs = attrs.first if attrs.first.instance_of? Array

      attrs.each do |attr|
        attribute attr, if: :sampled?
      end
    end

    def detailed_attributes(*attrs)
      attrs = attrs.first if attrs.first.instance_of? Array

      attrs.each do |attr|
        attribute attr, if: :detailed?
      end
    end
  end
end
