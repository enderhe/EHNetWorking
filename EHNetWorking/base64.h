/* gbase64.h - Base64 coding functions
 *
 *  Copyright (C) 2005  Alexander Larsson <alexl@redhat.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef __G_BASE64_H__
#define __G_BASE64_H__

#include <stdio.h>

#ifdef __cplusplus
extern "C"
{
#endif

size_t  base64_encode_step  (const unsigned char *in,
			       size_t         len,
			       int      break_lines,
			       char        *out,
			       int         *state,
			       int         *save);

size_t   base64_encode_close (int      break_lines,
			       char        *out,
			       int         *state,
			       int         *save);

//return need free
char*  base64Encode       (const unsigned char *data,
			       size_t         len);

size_t base64_decode_step  (const char  *in,
			       size_t         len,
			       unsigned char       *out,
			       int         *state,
			       unsigned int        *save);

//return need free
unsigned char *base64_decode       (const char  *text,
			       size_t        *out_len);

unsigned char *base64_decode_inplace (char      *text,
                                 size_t      *out_len);


#ifdef __cplusplus
}
#endif

#endif /* __G_BASE64_H__ */
