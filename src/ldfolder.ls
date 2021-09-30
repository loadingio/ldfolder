ldfolder = (opt) ->
  root = opt.root
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

  toggle: (menu, v, force = false, internal = false) ->
    ison = menu.parentNode.classList.contains \show
    if (v = if v? => v else !ison) == ison and !force => return
    if @exclusive and v and !internal =>
      Array.from(@root.querySelectorAll('.ldfd.show > .ldfd-menu')).map ~>
        if it.contains(menu) or menu.contains(it) => return
        @toggle it, false, false, true
    # `ch` - current height
    ch = getComputedStyle(menu).height or 0
    # 'sh' - get fit-content-height ( scrollHeight) by clear height
    menu.style.height = ""
    menu.offsetHeight # force relayout
    sh = menu.scrollHeight
    # restore height to current height
    menu.style.height = ch
    menu.offsetHeight # force relayout
    # ... and transition to destination value.
    menu.style.height = "#{if !v => 0 else sh}px"
    menu.parentNode.classList.toggle \show, v
    return v

if module? => module.exports = ldfolder
else window.ldfolder = ldfolder
