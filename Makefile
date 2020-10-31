################################################
CC = gcc
CCD = gcc -D DEBUG
CCA = gcc -D PLATFORM=ALLEGRO
CCR = gcc -D PLATFORM=RASPI
OPTIONS = -g -Wall	# -g for debug, -O2 for optimise and -Wall additional messages
################################################
ALLLINUXLIB =`pkg-config --libs allegro-5` `pkg-config --libs allegro_acodec-5` `pkg-config --libs allegro_audio-5` `pkg-config --libs allegro_color-5` `pkg-config --libs allegro_dialog-5` `pkg-config --libs allegro_font-5` `pkg-config --libs allegro_image-5` `pkg-config --libs allegro_main-5` `pkg-config --libs allegro_memfile-5` `pkg-config --libs allegro_physfs-5` `pkg-config --libs allegro_primitives-5` `pkg-config --libs allegro_ttf-5` `pkg-config --libs allegro_video-5`
ALLWINLIB = -l allegro -l allegro_audio -l allegro_acodec -l allegro_color -l allegro_font -l allegro_image -l allegro_primitives -l allegro_ttf
RPILINUXLIB = ../libs/joydisp/disdrv.h ../libs/joydisp/joydrv.h #../libs/audio/SDL1/libaudio.h
################################################
EVENTQ_OBJECT = Backend/event_queue/event_queue.o
EVENTQ_HEAD = Backend/event_queue/event_queue.h
################################################
TIMER_OBJECT = Frontend/Raspi/timer/timer.o
TIMER_HEAD	= Frontend/Raspi/timer/timer.h
###############################################
HFRONT_ALL = Frontend/Allegro/headall.h
HFRONT_RAS = Frontend/Raspi/headall.h
################################################
OBJS = Backend/main.o Backend/ingame_stats.o Backend/scoretable.o Backend/FSM_routines.o Frontend/Allegro/menu_front.o Frontend/Allegro/game_front.o ${EVENTQ_OBJECT}
OBJS2 = Backend/main.o Backend/ingame_stats.o Backend/scoretable.o Backend/FSM_routines.o Frontend/Raspi/menu_front.o Frontend/Raspi/game_front.o ${EVENTQ_OBJECT} ${TIMER_OBJECT} ../libs/joydisp/disdrv.o ../libs/joydisp/joydrv.o #../libs/audio/SDL1/libAudioSDL1.o
################################################


################# ALLEGRO ######################
game: ${OBJS}
	${CCA} ${OPTIONS} ${OBJS} ${ALLLINUXLIB} -o game

# Para Windows, se compila con las librerias de otra manera
win: ${OBJS} 
	${CCA} ${OPTIONS} ${OBJS} ${ALLWINLIB} -o game
#

Backend/main.o: Backend/main.c Backend/FSM_table.h Backend/FSM_routines.h ${EVENTQ_HEAD} const.h
	${CCR} ${OPTIONS} -c Backend/main.c -o Backend/main.o

Backend/ingame_stats.o: Backend/ingame_stats.c Backend/ingame_stats.h const.h
	${CCR} ${OPTIONS} -c Backend/ingame_stats.c -o Backend/ingame_stats.o

Backend/scoretable.o: Backend/scoretable.c Backend/scoretable.h
	${CCR} ${OPTIONS} -c Backend/scoretable.c -o Backend/scoretable.o

Backend/FSM_routines.o: Backend/FSM_routines.c Backend/FSM_routines.h ${EVENTQ_HEAD} Backend/scoretable.h Backend/ingame_stats.h ${HFRONT_ALL} const.h
	${CCR} ${OPTIONS} -c Backend/FSM_routines.c -o Backend/FSM_routines.o

Frontend/Allegro/menu_front.o: Frontend/Allegro/menu_front.c ${HFRONT_ALL} ${EVENTQ_HEAD} Frontend/Allegro/shared_res.h const.h
	${CCA} ${OPTIONS} -c Frontend/Allegro/menu_front.c -o Frontend/Allegro/menu_front.o

Frontend/Allegro/game_front.o: Frontend/Allegro/game_front.c ${HFRONT_ALL} ${EVENTQ_HEAD} Frontend/Allegro/shared_res.h const.h
	${CCA} ${OPTIONS} -c Frontend/Allegro/game_front.c -o Frontend/Allegro/game_front.o
#################################################


################### RASPI #######################
gameraspi: ${OBJS2} 
	${CCR} ${OPTIONS} ${OBJS2} -o gameraspi

# Backend/main.o: Backend/main.c Backend/FSM_table.h Backend/FSM_routines.h ${EVENTQ_HEAD} const.h
# 	${CCR} ${OPTIONS} -c Backend/main.c -o Backend/main.o

# Backend/ingame_stats.o: Backend/ingame_stats.c Backend/ingame_stats.h const.h
# 	${CCR} ${OPTIONS} -c Backend/ingame_stats.c -o Backend/ingame_stats.o

# Backend/scoretable.o: Backend/scoretable.c Backend/scoretable.h
# 	${CCR} ${OPTIONS} -c Backend/scoretable.c -o Backend/scoretable.o

# Backend/FSM_routines.o: Backend/FSM_routines.c Backend/FSM_routines.h ${EVENTQ_HEAD} Backend/scoretable.h Backend/ingame_stats.h ${HFRONT_RAS} const.h
# 	${CCR} ${OPTIONS} -c Backend/FSM_routines.c -o Backend/FSM_routines.o

Frontend/Raspi/game_front.o: Frontend/Raspi/game_front.c ${HFRONT_RAS} ${RPILINUXLIB} ${EVENTQ_HEAD} const.h
	${CCR} ${OPTIONS} -c Frontend/Raspi/game_front.c -o Frontend/Raspi/game_front.o

Frontend/Raspi/menu_front.o: Frontend/Raspi/menu_front.c ${HFRONT_RAS} ${RPILINUXLIB} ${EVENTQ_HEAD} const.h
	${CCR} ${OPTIONS} -c Frontend/Raspi/menu_front.c -o Frontend/Raspi/menu_front.o
#################################################

################## GENERIC ######################
Backend/event_queue/event_queue.o: Backend/event_queue/event_queue.c ${EVENTQ_HEAD}
	${CC} ${OPTIONS} -c Backend/event_queue/event_queue.c -o Backend/event_queue/event_queue.o

Frontend/Raspi/timer/timer.o: Frontend/Raspi/timer/timer.c ${TIMER_HEAD} 
	${CC} ${OPTIONS} -c Frontend/Raspi/timer/timer.c -o Frontend/Raspi/timer/timer.o
#################################################

clean:
	rm Backend/*.o
	rm Frontend/Raspi/*.o
	rm Frontend/Allegro/*.o

clean_ge:
	rm Backend/event_queue/*.o
	rm Frontend/Raspi/timer/*.o

cleanwin:
	del *.o /S