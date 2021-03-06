require 'stdlib/area/area'

describe('Area Spec', function()
    it('should validate whether positions are inside of an area', function()
        local pos = {1, -4}
        local area = {left_top = {0, -5}, right_bottom = {x = 3, y = -3}}
        assert.truthy(Area.inside(area, pos))

        local area = {left_top = {100, 100}, right_bottom = {95, 95}}
        assert.falsy(Area.inside(area, pos))
    end)

    it('should validate the integer representation of an area', function()
        local area = {left_top = {0.3, -0.7}, right_bottom = {x = 3.2, y = 2.6}}
        assert.same({x = 0, y = -1}, Area.round_to_integer(area).left_top)
        assert.same({x = 4, y = 3}, Area.round_to_integer(area).right_bottom)
    end)

    it('should validate area offsets', function()
        local area = {{0, -5}, {x = 3, y = -3}}
        local pos = {-0.5, 2.5}
        assert.same({x = -0.5, y = -2.5}, Area.offset(area, pos).left_top)
        assert.same({x = 2.5, y = -0.5}, Area.offset(area, pos).right_bottom)
    end)

    it('should validate area shrinks accurately', function()
        local area = {{0, -2}, {x = 3, y = 2}}
        assert.same({x = 1, y = -1}, Area.shrink(area, 1).left_top)
        assert.same({x = 2, y = 1}, Area.shrink(area, 1).right_bottom)

        assert.has_error(function() Area.shrink(area, -1) end)
    end)

    it('should validate area expands accurately', function()
        local area = {{0, -2}, {x = 3, y = 2}}
        assert.same({x = -1, y = -3}, Area.expand(area, 1).left_top)
        assert.same({x = 4, y = 3}, Area.expand(area, 1).right_bottom)

        assert.has_error(function() Area.expand(area, -1) end)
    end)

    it('should validate area to table conversation', function()
        local area = {{0, -5}, {x = 3, y = -3}}
        assert.same({x = 0, y = -5}, Area.to_table(area).left_top)
        assert.same({x = 3, y = -3}, Area.to_table(area).right_bottom)

        assert.has_error(function() Area.to_table(nil) end)
    end)

    it('should validate area iteration', function()
        local area = {{0, -5}, {x = 3, y = -3}}
        local expected_iteration = {
          {0, -5},
          {1, -5},
          {2, -5},
          {3, -5},
          {0, -4},
          {1, -4},
          {2, -4},
          {3, -4},
          {0, -3},
          {1, -3},
          {2, -3},
          {3, -3}
        }
        local idx = 1
        for x, y in Area.iterate(area) do
            assert.same(expected_iteration[idx][1], x, "Idx: " .. idx)
            assert.same(expected_iteration[idx][2], y, "Idx: " .. idx)
            idx = idx + 1
        end
    end)
end)
