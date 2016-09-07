local Helpers = {}

-- needed to deal with situations when going crossing the 2 * pi rad mark,
-- i.e. when numeric difference between current rotation and target rotation is greater than pi, 
-- but actual rotation difference is less than pi
function Helpers.distanceToTargetRotation(currentRotation, targetRotation)
  if math.abs(targetRotation - currentRotation) > math.pi then
    if currentRotation > targetRotation then
      currentRotation = currentRotation - 2 * math.pi
    elseif targetRotation > currentRotation then
      targetRotation = targetRotation - 2 * math.pi
    end
  end
  return targetRotation - currentRotation
end

return Helpers
