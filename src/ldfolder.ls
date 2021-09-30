ldfolder = (opt) ->
  root = opt.root
  @_delta = wk: new WeakMap!, set: new Set!
  @exclusive = opt.exclusive or false
  @root = root = if typeof(root) == \string => document.querySelector(root) else if root => root else null
  @root.addEventListener \click, (e) ~>
    n = e.target
    while n and n != @root and (!n.matches or (n.matches and !n.matches \.ldfd-toggle )) => n = n.parentNode
    if !(n and n != @root) => return
    p = n
    while (p = p.nextSibling) => if (p.classList and p.classList.contains \ldfd-menu) => break
    if p => @toggle p
  return @

ldfolder.prototype = Object.create(Object.prototype) <<< do
  fit: (menu) -> @toggle menu, menu.parentNode.classList.contains(\show), true

  # - menu: .ldfd-menu node
  # - v: true to open, false to close. undefined to toggle.
  # - force: force update even if state is the same
  # - internal: called internally, to ignore some check like exclusive
  # - delta: passed from child. provide information about delta of child menu height for parent to adopt
  toggle: (menu, v, force = false, internal = false) ->
    @_toggle menu,v, force, internal
    s = @_delta.set
    while s.size =>
      list = Array.from s
      s.clear!
      list.map ~>
        is-on = it.parentNode.classList.contains \show
        @_toggle it, is-on, true, true

  _toggle: (menu, v, force = false, internal = false) ->
    ison = menu.parentNode.classList.contains \show
    if (v = if v? => v else !ison) == ison and !force => return
    if @exclusive and v and !internal =>
      Array.from(@root.querySelectorAll('.ldfd.show > .ldfd-menu')).map ~>
        if it.contains(menu) or menu.contains(it) => return
        @_toggle it, false, false, true
    # `ch` - current height
    ch = getComputedStyle(menu).height or 0
    # 'sh' - get fit-content-height ( scrollHeight) by clear height
    menu.style.height = ""
    menu.offsetHeight # force relayout
    delta = 0
    if internal =>
      delta = @_delta.wk.get(menu) or 0
      @_delta.wk.delete menu

    sh = menu.scrollHeight + delta
    # restore height to current height
    menu.style.height = ch
    menu.offsetHeight # force relayout
    # ... and transition to destination value.
    menu.style.height = "#{if !v => 0 else sh}px"
    menu.parentNode.classList.toggle \show, v
    n = menu
    while n.parentNode and n.parentNode != @root
      n = n.parentNode
      if !n.matches('.ldfd-menu') => continue
      @delta n, ((if !v => 0 else sh) - +ch.replace('px',''))
      #@toggle n, true, true, true, ((if !v => 0 else sh) - +ch.replace('px',''))
      break
    return v
  delta: (node, value) ->
    @_delta.wk.set node, ret = (@_delta.wk.get(node) or 0) + value
    @_delta.set.add node

if module? => module.exports = ldfolder
else window.ldfolder = ldfolder
