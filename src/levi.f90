!-----------------------------------------------------------------------
! 
!  levi.f90
!
!  Simple program to make "levi" type flights much faster than a real
!  mot simulation. Sorta to test out the whole simulation thing.
! 
!-----------------------------------------------------------------------


program levi

  use globals
  use random_pl
  use utilities

  implicit none

  !-----------------------------------------------------------------
  !
  ! Begin Variable Declarations
  !
  !-----------------------------------------------------------------
 
  real(wp), dimension(3,2) :: y0   !      -> initial conditions storage
  integer(rpk) :: seed             !      -> Seed for RNG

  integer :: steps = 100           !      -> total simulation length
  integer :: step = 0              !      -> current time

  integer :: thresh                !      -> velocity threshhold for motion
  real(wp) :: gamma                !      -> velocity damping rate

  integer, parameter :: dim = 3
  real(wp), dimension(dim) :: x      !      -> position
  real(wp), dimension(dim) :: v      !      -> velocity
  integer :: i

  !-----------------------------------------------------------------
  !
  ! End Variable Declarations
  !
  !-----------------------------------------------------------------


  !-----------------------------------------------------------------
  !
  ! Get file input.
  !
  !-----------------------------------------------------------------
  character(len=100) :: label, ctrl_file
  integer :: pos
  integer, parameter :: fh = 15
  integer :: ios = 0
  integer :: line = 0
  character(256) :: buff


  if ( command_argument_count() .ne. 1 ) then
     stop 0
  end if
  call get_command_argument(1, ctrl_file)

  !!!!!! Get arguments from the command line
  open(fh, file=ctrl_file)

  ! ios is negative if an end of record condition is encountered or if
  ! an endfile condition was detected.  It is positive if an error was
  ! detected.  ios is zero otherwise.
  do while (ios == 0)
     read(fh, '(A)', iostat=ios) buff
     if (ios == 0) then
        line = line + 1

        ! Find the first instance of whitespace.  Split label and data.
        pos = scan(buff, '    ')
        label = buff(1:pos)
        buff = buff(pos+1:)


        select case (label)

           case('gamma')
              gamma = s2r(buff)
              write(0,*) 'Read ', label, ': ', gamma

           case('thresh')
              thresh = s2i(buff)
              write(0,*) 'Read ', label, ': ', thresh

           case('steps')
              steps = s2i(buff)
              write(0,*) 'Read ', label, ': ', steps

           case('seed')
              seed = s2i(buff)
              write(0,*) 'Read ', label, ': ', seed
              call init_rand_pl(seed1=seed)

           case default
              write(0,*) 'Unknown label, Read ', label, ': ', buff

           end select
        end if
     end do
  !-----------------------------------------------------------------
  !
  ! End get file input.
  !
  !-----------------------------------------------------------------



  do i = 1, dim
     x(i) = 0
     v(i) = 0
  end do

   


  !-----------------------------------------------------------------
  !
  ! Main Simulation
  !
  !-----------------------------------------------------------------
 
    write(0,*) "Starting simulation."

    do step = 0, steps
       write(*,*) step, x(1), x(2), x(3), v(1), v(2), v(3)

       ! Velocity kicks
       do i = 1, dim
          v(i) = (v(i) + 1 - 2*rand_pl())*(1-gamma)
       end do

       ! If out of well, do motion
       if ( sqrt( dot_product(v,v) ) .gt. thresh ) then
          x = x + v
       end if

    end do

    write(0,*) "Finished simulation."

  !-----------------------------------------------------------------
  !
  ! End Main Simulation
  !
  !-----------------------------------------------------------------



end program levi

