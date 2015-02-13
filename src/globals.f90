!-----------------------------------------------------------------------
!
!  Globals module.  Put all variables to be accessible everywhere
!    here. 
!
!-----------------------------------------------------------------------

module globals
! WP normally is 14
  integer, parameter     :: wp = selected_real_kind(p=14)   ! this sets the floating-point precision to double
  real(wp), parameter    :: pi = 3.14159265358979_wp        ! pi! REAL: VERY WEIRD BUGS HAPPEN IF YOU SET PI=3

  ! settings for the portable random number generator rand_pl
  integer, parameter :: rand_pl_wp = wp    ! get double-precision random #s
  integer, parameter :: rand_pl_mf = 100   ! use simple, fast generator

end module globals
