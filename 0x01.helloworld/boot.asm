;系统启动引导程序
;
;程序装载地址必须为0x7c00H，大小512b，0xaa55h结尾 
;Memory Map (x86) http://wiki.osdev.org/index.php?title=Memory_Map_(x86)&oldid=13415
;
;BIOS 中断说明
;https://en.wikipedia.org/wiki/BIOS_interrupt_call
;
;BIOS颜色表
;https://en.wikipedia.org/wiki/BIOS_color_attributes
;
;编译运行命令:
;	nasm boot.asm -o boot.bin
;	dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc
; 
;测试环境:bochs
;	 bximage 创建软盘
; 
	org 07c00h ;7c00~7dff 为系统启动区
	;初始化段寄存器	
	mov ax,0
	mov ds,ax
	mov es,ax
	mov ss,ax

	call bootstrap
fin:
	hlt
	jmp fin

bootstrap:
	mov si,Bootmessage
	mov cx,BootmessageLength
.printmessage:	
	mov al,[si];加载一个字符    
	add si,1
	mov ah,0eh ;0e功能号 显示一个文字 
	mov bx,04h ;指定颜色 https://en.wikipedia.org/wiki/BIOS_color_attributes
	int 10h    ;bios 10h中断
	dec cx
	cmp cx,0
	JNE .printmessage
	ret

Bootmessage: db 10,"Hello, World!",10
BootmessageLength: equ $-Bootmessage
times 510-($-$$) db 0
dw 0xaa55
